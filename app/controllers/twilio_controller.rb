class TwilioController < ApplicationController
  # include Webhookable

  # after_action :set_header

  skip_before_action :verify_authenticity_token, only: [:update]

  def create
    player = Player.find(params[:player_id])
    phone = player.profile.guardian_phone
    @client = Twilio::REST::Client.new ENV['live_twilio_sid'], ENV['live_twilio_token']
    # session["unique_id"] ||= "abc123"
    @message = @client.messages.create({
      to: "+1#{phone}",
      from: "+13157571027",
      body: 'This is a message sent from youth sports'
      })

      Prospect.create(recruiter_profile_id: current_user.profile.id,
                         player_profile_id: player.profile.id)


      flash[:notice] = "You've sent a request to the player's guardian."
      redirect_to profiles_path(player)
  end

  def update
    phone = params[:From]
    phone[0] = ''
    player_prospects = PlayerProfile.find_by(guardian_phone: phone).prospects[0]
    if params[:Body] == "Yes"
      player_prospects.status = "prospect"
      player_prospects.save
    elsif params[:Body] == "No"
      player_prospects.status = "denied"
      player_prospects.save
    end
    # response = Twilio::TwiML::Response.new do |r|
    #   r.Say "Thanks for responding...INSERT APPROPRIATE MESSAGE"
    # end
    #
    # render_twiml response
  end

end
