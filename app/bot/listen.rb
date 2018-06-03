require "facebook/messenger"
require "message_formatter"
include Facebook::Messenger
include Rails.application.routes.url_helpers
include MessageFormatter
default_url_options[:host] = "413d3f9d.ngrok.io"
Facebook::Messenger::Subscriptions.subscribe(access_token: Rails.application.credentials.facebook[:access_token])
Bot.on :message do |message|
  if message.text[0].chr == '/'
    command = message.text.split.first
    case command
    when '/recipe'
      offset = rand(Recipe.count)
      rand_record = Recipe.offset(offset).first

      reply = {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: "Why not prepare #{rand_record.title} tonight?",
            buttons: [
              { type: 'postback', title: 'Sounds cool!', payload: "#{rand_record.id}" },
              { type: 'postback', title: 'No, send another', payload: 'NO' }
            ]
          }
        }
      }    
    else
      reply = {text: 'Sorry I did not get that...'}
    end
  else
    reply = {text: "Hello there!"}
  end
  message.reply(
    reply
  )
end

Bot.on :postback do |postback|
  postback.sender    # => { 'id' => '1008372609250235' }
  postback.recipient # => { 'id' => '2015573629214912' }
  postback.sent_at   # => 2016-04-22 21:30:36 +0200
  postback.payload   # => 'EXTERMINATE'

  if postback.payload == 'NO'
    offset = rand(Recipe.count)
    rand_record = Recipe.offset(offset).first
    reply = {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: "Let's try another one. How about #{rand_record.title} tonight?",
            buttons: [
              { type: 'postback', title: 'Sounds cool!', payload: "#{rand_record.id}" },
              { type: 'postback', title: 'No, send another', payload: 'NO' }
            ]
          }
        }
      }    
  else
    recipe = Recipe.find(postback.payload)
    #reply = {text: "To prepare #{recipe.title}, you wil need \n #{recipe.ingredients} \n
   # Here's waht you need to do:\n #{recipe.directions}"}
   #reply = {
      #"attachment": {
      #  "type": "template",
      #  "payload": {
      #    "template_type": "list",
      #    "top_element_style": "compact",
          #"text": "#{recipe.title}",
      #    "elements": MessageFormatter.ingriedient_list(recipe)
      #  }
      #}
    #}
    reply = MessageFormatter.carousel(recipe)
  end
  begin
  postback.reply(
    reply
  )
  rescue => error
    Rails.logger.info(error)
    postback.reply(
      {text: "Sorry, something went wrong. Please wisit #{recipe_url(recipe)} in your browser."}
    )
  end
end


