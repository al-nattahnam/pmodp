class Parser
  def initialize(path)
    file = File.read(path)
    @lines = file.lines

    @data_objects = {}
    @context_roles = {}
    @interaction = {}

    @state = :idle
  end

  def parse
    next_line
    while @line
      parse_current
      
      raise "invalid specification" if @state == :error
      break if @state == :error

      break if @state == :quit
    end
    #log "exit."

    return {
      :data_objects => @data_objects,
      :roles => @context_roles,
      :interaction => @interaction
    }
    
    rescue
      log "error."

  end

  def next_line
    @line = @lines.next
    rescue StopIteration
      @state = :quit
  end

  def parse_current
    case @state
      when :idle
        parse_as_idle
      when :object_begins, :object_header, :object_definition
        parse_as_object_definition
      when :role_begins, :role_definition
        parse_as_role_definition
      when :algorithm
        parse_as_algorithm
    end
  end

  def parse_as_idle
    match_is_comment = @line.match(is_comment)
    match_is_blank = @line.match(is_blank)
    match_is_object = @line.match(object_definition_header)
    match_is_role = @line.match(role_definition_header)
    match_is_algorithm = @line.match(algorithm_definition)

    if match_is_comment
      # log "COMMENT: #{@line}"
      next_line
    elsif match_is_blank
      # log "-- blank --"
      next_line
      @state = :idle
    elsif match_is_object
      @state = :object_begins
    elsif match_is_role
      @state = :role_begins
    elsif match_is_algorithm
      @state = :algorithm
    else
      @state = :error
    end
  end

  def parse_as_object_definition
    match_header = @line.match(object_definition_header)

    match_definition = @line.match(object_definition_body) if @line.match(is_indented)

    if match_header
      @state = :object_header
      
      key = match_header[1]
      aliases = [match_header[4]]

      @current_object_key = key

      @data_objects[key] = {}
      @data_objects[key][:aliases] = aliases
      @data_objects[key][:attrs] = []
      @data_objects[key][:is] = []

      next_line
      # @state = :quit
    elsif match_definition
      @state = :object_definition

      kind = match_definition[2].to_sym
      value = match_definition[3]

      if [:is, :attrs].include?(kind)
        @data_objects[@current_object_key][kind] << value
      end

      next_line
    else
      @state = :idle
    end
  end

  def parse_as_role_definition
    match_header = @line.match(role_definition_header)

    if match_header
      @state = :role_definition
      
      role_name = match_header[1]
      role_module = match_header[2]

      @context_roles[role_name] = role_module

      # log role.inspect
      
      next_line
    else
      @state = :idle
    end
  end

  def parse_as_algorithm
    match_header = @line.match(algorithm_definition)

    if match_header
      data_object_name = match_header[1]
      method_chain = match_header[2].split(",").collect(&:strip)

      method_chain.each_with_index do |method_name, i|
        # if this is an igniter method...

        if i > 0
          previous_method_name = method_chain[i - 1]
          triggered_by = "#{data_object_name}.#{previous_method_name}"
        end
        
        action = "#{data_object_name}.#{method_name}"
        @interaction[action] ||= {:triggered_by => [], :data_object => data_object_name}
        @interaction[action][:triggered_by] << triggered_by if triggered_by

      end

      @interaction[data_object_name]

      next_line
    else
      @state = :idle
    end
  end

  def log(output)
    $stdout.puts "#{@state} : #{output}"
  end

  private
  def is_blank
    /^$|^[\s+]/
  end

  def is_indented
    /^\s\s/
  end

  def is_comment
    /^#/
  end
  
  def object_definition_header
    # format = <:message> or (:msg)
    /<:(.+)>($|(\sor\s\(:(\w+)\)))/
  end

  def object_definition_body
    # format = - attrs(:attr_name)
    # format = - is(:role)
    /^\s\s-\s((attrs|is)\(:(\w+)\))/
  end

  def role_definition_header
    /^~(\w+)\sfrom\s(\w+)/
  end

  def algorithm_definition
    /\(:(\w+)\)\s:\s([(\w+),\s]+)/
  end
end
