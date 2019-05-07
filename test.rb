# test.rb

app_pid = fork {
  # will be run in the child process
  # parent never reaches here
  load 'app.rb'
}

# will be run in the parent process
# child never reaches here

10.times { |i| puts "shutting down in #{10-i}"; sleep 1 }

Process.kill(:INT, app_pid)
