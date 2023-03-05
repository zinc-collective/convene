class Marketplace
  class TaxRatesController < Controller
    def new
      tax_rate
    end

    def create
      if tax_rate.save
        redirect_to marketplace.location(child: :tax_rates)
      else
        render :new
      end
    end

    def tax_rate_params
      policy(TaxRate).permit(params.require(:tax_rate))
    end

    helper_method def tax_rate
      @tax_rate ||= if params[:id]
        policy_scope(marketplace.tax_rates).find(params[:id])
      elsif params[:tax_rate]
        marketplace.tax_rates.new(tax_rate_params)
      else
        marketplace.tax_rates.new
      end.tap do |tax_rate|
        authorize(tax_rate)
      end
    end
  end
end
