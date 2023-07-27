module Spec
  class StripeCLI
    module Helpers
      # Launches `stripe listen` with the provided url in a background thread,
      # waits up to 5 seconds for the webhook signing secret to be assigned,
      # then yields the secret to the passed in block.
      def stripe_listen(forward_to:, events: ["*"], api_key: ENV.fetch("STRIPE_API_KEY"), &block)
        signing_secret = nil
        waiting = 0
        command = "stripe listen --events #{events.join(",")}  --api-key #{api_key} --forward-to #{forward_to}"
        thread = Thread.new do
          Open3.popen3(command) do |_, stdout, stderr, thread|
            # read each stream from a new thread
            [stdout, stderr].each do |stream|
              Thread.new do
                until (raw_line = stream.gets).nil?
                  signing_secret = raw_line[/whsec_\w+/] if raw_line.include?("webhook")
                  Rails.logger.info(raw_line)
                end
              end
            end
            thread.join
          end
        end

        until signing_secret
          raise "Can't connect to Stripe!" if waiting > 5
          waiting += 1
          sleep(1)
        end

        yield(signing_secret)
        thread.kill
      end
    end
  end
end
