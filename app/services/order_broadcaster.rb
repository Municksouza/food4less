# app/services/order_broadcaster.rb
class OrderBroadcaster
  include Rails.application.routes.url_helpers

  def initialize(order)
    @order  = order
    @stream = "store_#{order.store.id}_orders"
    @dom_id = "order-#{order.id}"
  end

  # 1. NEW ORDER → append em pending + tocar som
  def broadcast_new
    rendered = render_partial(play_sound: true)

    Turbo::StreamsChannel.broadcast_action_to(
      @stream,
      action:  :append,
      target:  "pending-orders",
      content: rendered
    )

    # <-- aqui, payload como Hash posicional:
    ActionCable.server.broadcast(@stream, { playSound: true })
  end

  # 2. ACCEPT → remove de pending + append em in‑progress + parar som
  def broadcast_accept
    rendered = render_partial(play_sound: false)

    Turbo::StreamsChannel.broadcast_action_to(
      @stream,
      action: :remove,
      target: @dom_id
    )

    Turbo::StreamsChannel.broadcast_action_to(
      @stream,
      action:  :append,
      target:  "in-progress-orders",
      content: rendered
    )

    ActionCable.server.broadcast(@stream, { stopSound: true })
  end

  # 3. REJECT → remove de pending + parar som
  def broadcast_reject
    Turbo::StreamsChannel.broadcast_action_to(
      @stream,
      action: :remove,
      target: @dom_id
    )

    ActionCable.server.broadcast(@stream, { stopSound: true })
  end

  private

  def render_partial(play_sound:)
    ApplicationController.renderer.render(
      partial: "stores/orders/order",
      formats: [:html],
      locals:  { order: @order, play_sound: play_sound }
    )
  end
end