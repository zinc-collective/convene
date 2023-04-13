class Marketplace
  class TaxRatesController < Controller
    def new
      tax_rate
    end

    def index
    end

    def create
      if tax_rate.save
        redirect_to marketplace.location(child: :tax_rates)
      else
        render :new
      end
    end

    def edit
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(tax_rate, partial: "form")
        end

        format.html
      end
    end

    def update
      tax_rate.update(tax_rate_params)

      respond_to do |format|
        format.turbo_stream do
          if tax_rate.errors.empty?
            render turbo_stream: turbo_stream.replace(tax_rate, TaxRateComponent.new(tax_rate: tax_rate).render_in(view_context))
          else
            render turbo_stream: turbo_stream.replace(tax_rate, partial: "form")
          end
        end

        format.html do
          if tax_rate.errors.empty?
            redirect_to marketplace.location(child: :tax_rates)
          else
            render :edit
          end
        end
      end
    end

    def destroy
      tax_rate.destroy

      respond_to do |format|
        format.turbo_stream do
          if tax_rate.destroyed?
            render turbo_stream: turbo_stream.remove(tax_rate)
          else
            render turbo_stream: turbo_stream.replace(tax_rate)
          end
        end

        format.html do
          if tax_rate.destroyed?
            redirect_to marketplace.location(child: :tax_rates)
          else
            render :show
          end
        end
      end
    end

    def tax_rate_params
      policy(TaxRate).permit(params.require(:tax_rate))
    end

    helper_method def tax_rate
      @tax_rate ||= if params[:id]
        tax_rates.find(params[:id])
      elsif params[:tax_rate]
        tax_rates.new(tax_rate_params)
      else
        tax_rates.new
      end.tap do |tax_rate|
        authorize(tax_rate)
      end
    end

    helper_method def tax_rates
      @tax_rates ||= policy_scope(marketplace.tax_rates)
    end
  end
end
