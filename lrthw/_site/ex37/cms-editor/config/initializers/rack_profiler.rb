# Initialise rack-mini-profiler
require 'rack-mini-profiler'

# initialization is skipped so trigger it
Rack::MiniProfilerRails.initialize!(Rails.application)

# By default hide the profiling widget. The shortcut key for displayig it is Alt+p
Rack::MiniProfiler.config.start_hidden = true
