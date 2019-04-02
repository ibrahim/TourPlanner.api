class Profiler
  def initialize(app)
    @app = app
  end

  def profiling_filename(env)
    filename_friendly_path = env['PATH_INFO'].tr('/',' ').strip.tr(' ','-')
    filename_friendly_path = 'root' if filename_friendly_path == ""

    "#{filename_friendly_path}.prof.txt"
  end

  def call(env)
    # Begin profiling
    RubyProf.measure_mode = RubyProf::WALL_TIME
    RubyProf.start

    # Run all app code
    res = @app.call(env)

    # Stop profiling & save
    out = RubyProf.stop
    File.open("#{ENV['PROF_OUT']}/#{profiling_filename(env)}", "w+") do |file|
      RubyProf::FlameGraphPrinter.new(out).print(file)
    end

    res
  end
end
