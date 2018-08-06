class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write "<h1>Cart</h1>"
      resp.write "<ul>"
      @@cart.each do |item|
        resp.write "<li>#{item}</li>"
      end
      resp.write "</ul>"
    elsif req.path.match(/add/)
      item = req.params["item"]
      if @@items.include?(item)
        @@cart << item
        resp.write "Item Added"
      else
        resp.write "Couldn't Find Item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
