// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.
console.log("consumerloaded ✅")

import { createConsumer } from "@rails/actioncable";

export default createConsumer();