def parse(constant)
  source, _, constant_name = constant.to_s.rpartition("::")

  [source.constantize, constant_name]
end

def with_constants(constants, &block)
  saved_constants = {}
  constants.each do |constant, val|
    source_object, const_name = parse(constant)

    saved_constants[constant] = source_object.const_get(const_name)
    Kernel::silence_warnings { source_object.const_set(const_name, val) }
  end

  begin
    block.call
  ensure
    constants.each do |constant, val|
      source_object, const_name = parse(constant)

      Kernel::silence_warnings { source_object.const_set(const_name, saved_constants[constant]) }
    end
  end
end

def with_environment(environment, &block)
  old_globals = $globals
  $globals = Globals.read("config/globals.yml", environment)

  block.call

  $globals = old_globals
end

def with_user(user, &block)
  with_constants :ENV => {'USER' => user}, &block
end