Handler = Proc.new do |req, res|
  res.status = 200
  res['Content-Type'] = 'text/html; charset=utf-8'
  res.body = "Current Time: #{Time.new}"
end
