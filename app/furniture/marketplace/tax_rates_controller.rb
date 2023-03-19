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

    def update
      if tax_rate.update(tax_rate_params)
        redirect_to marketplace.location(child: :tax_rates)
      else
        render :edit
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
