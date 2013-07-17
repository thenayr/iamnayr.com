worker_processes 6
timeout          30
preload_app      true
work_dir = "/var/www/iamnayr.com/"

socket_path = "#{work_dir}tmp/sockets/unicorn.sock"
pid_path = "#{work_dir}tmp/pids/unicorn.pid"
err_log = "#{work_dir}log/unicorn.stderr.log"
out_log = "#{work_dir}log/unicorn.stdout.log"
