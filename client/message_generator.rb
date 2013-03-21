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

    def process(id, content)
      # This is the incoming message, given by the Application
      msg = <<eos
PROCESS #{version}
Id: #{id}
Content: #{content}
eos
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
  end
end
