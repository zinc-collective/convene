class Journal::EntriesController < FurnitureController
  def new; end

  def create
    if entry.save
      redirect_to [space, room]
    else
      render :new
    end
  end

  def edit; end

  def update
    if entry.update(entry_params)
      redirect_to entry.location
    else
      render :edit
    end
  end

  def destroy
    entry.destroy
    redirect_to [space, room]
  end

  helper_method def entry
    return @entry if defined? @entry

    @entry = if params[:id]
               journal.entries.friendly.find(params[:id])
             elsif params[:entry]
               journal.entries.new(entry_params)
             else
               journal.entries.new
             end

    authorize(@entry)
  end

  def entry_params
    policy(Journal::Entry).permit(params.require(:entry))
  end

  helper_method def journal
    Journal::Journal.find_by(id: params[:journal_id])
  end
end
