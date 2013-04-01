class MessageGenerator
  
  class << self
    def version
      "PMODP/0.1"
    end

#    def registration(mod, events, needs_message=true, observer_only=false)
#      msg = <<eos
#REGISTER #{version}
#Module: #{mod}
#Events: #{events.join(",")}
#Needs-Message: #{needs_message}
#Observer-Only: #{observer_only}
#eos
#    end

    def login(mod)
      msg = <<eos
LOGIN #{mod} #{version}
Module: #{mod}
eos
    end

    def process(mod, process_name, additionals)
      # This is the incoming message, given by the Application
      msg = <<eos
PROCESS #{mod}##{process_name} #{version}
eos
      additionals.each do |k,v|
        msg << "#{k}: #{v}\n"
      end

      msg
    end
    
    def delegation(mod, id, content=nil)
      msg = <<eos
DELEGATE #{mod} #{version}
Module: #{mod}
Id: #{id}
eos
      msg += "Content: #{content}\n" if content
      msg
    end

    def return(mod, id)
      msg = <<eos
RETURN #{version}
From: #{mod}
Id: #{id}
eos
    end
    
    def event(mod, event, additionals={})
      msg = <<eos
EVENT #{mod}:#{event} #{version}
Module: #{mod}
eos
      # TODO add Id: UUID ?
      additionals.each do |k,v|
        msg << "#{k}: #{v}\n"
      end

      msg
    end
    
    def new_event(role_name, message, context=nil, additionals={})
      destination = ""
      destination << "#{role_name}##{message}"
      destination << "@#{context}" if context
      msg = <<eos
MSG #{destination} #{version}
eos
      # TODO add Id: UUID ?
      additionals.each do |k,v|
        msg << "#{k}: #{v}\n"
      end

      msg
    end

    def new_listen_up(application_name, context_name)
      msg = <<eos
NEW_CONTEXT #{application_name}#new_context #{version}
eos

    end
  end
end
