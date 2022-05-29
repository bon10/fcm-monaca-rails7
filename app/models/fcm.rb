require 'fcmpush'

class Fcm
  def self.push(token,title,body)
    project_id   = ENV['PROJECT_ID']
    client  = Fcmpush.new(project_id)
    payload = { # ref. https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
      message: {
        token: token,
        notification: {
          title: title,
          body: body
        }
      }
    }

    response = client.push(payload)
    json = response.json
    Rails.logger.info json[:name] # => "projects/[your_project_id]/messages/0:1571037134532751%31bd1c9631bd1c96"
  end
end
