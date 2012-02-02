if hector_root = Dir[File.join(File.dirname(__FILE__), "*.hect")].first
  desc "Run Hector daemon (#{File.basename(hector_root)})"
  task :hector do
    ENV["RUBYLIB"] = "test/lib/hector/lib"
    ENV["HECTOR_ROOT"] = hector_root
    exec "test/lib/hector/bin/hector daemon"
  end
end
