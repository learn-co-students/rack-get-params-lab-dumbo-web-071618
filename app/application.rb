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
      resp.write cart
    elsif req.path.match(/add/)
      product = req.params["item"]
      resp.write add(product)
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

  def cart
    if @@cart == []
      return "Your cart is empty"
    else
      @@cart.join("\n")
    end
  end

  def add(product)
    if @@items.include?(product)
      @@cart << product
      return "added #{product}"
    else
      return "We don't have that item"
    end
  end
  #the end below closes the class
end
