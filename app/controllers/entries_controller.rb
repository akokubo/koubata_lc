class EntriesController < ApplicationController
  # POST /entries
  # POST /entries.json
  def create
    @task = Task.find(params[:entry][:task_id])
    current_user.entry!(@task)
    respond_to do |format|
      format.html { redirect_to @task }
      format.js
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @task = Entry.find(params[:id]).task
    current_user.unentry!(@task)
    respond_to do |format|
      format.html { redirect_to @task }
      format.js
    end
  end
end
