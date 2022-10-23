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
    if entry.update(journal_entry_params)
      render :show
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
             elsif params[:journal_entry]
               journal.entries.new(journal_entry_params)
             else
               journal.entries.new
             end

    authorize(@entry)
  end

  def journal_entry_params
    policy(Journal::Entry).permit(params.require(:journal_entry))
  end

  helper_method def journal
    Journal.find_by(room: room)
  end
end
