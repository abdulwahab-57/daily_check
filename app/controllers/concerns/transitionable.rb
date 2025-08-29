module Transitionable
  extend ActiveSupport::Concern

  included do
    before_action :set_stateful_resource, only: [ :change_state ]
  end

  def change_state
    event = params[:event]
    if @resource.can_transition_to?(event)
      @resource.aasm.fire!(event.to_sym)
      redirect_to @resource, notice: "#{event.humanize} successful!"
    else
      redirect_to @resource, alert: "Invalid transition: #{event}"
    end
  end

  private

  def set_stateful_resource
    model_class = controller_name.classify.constantize
    @resource = model_class.find(params[:id])
  end
end
