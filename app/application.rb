# require 'pry'
class Application
  @@items = ["Apples","Carrots","Pears"]
  # Create a new class array called @@cart to hold any items in your cart
  @@cart = []

  def call env
    # Reordered according to preference/occurrence
    req = Rack::Request.new env
    res = Rack::Response.new
    # Refactored to use #ternary
    req.path.match(/items/) ? list(@@items, res) :
    req.path.match(/search/) ? handle_search(req, res) :
    # Create a new route called /cart to show the items in your cart
    req.path.match(/cart/) ? handle_cart(res) :
    # Create a new route called /add
    req.path.match(/add/) ? handle_add(req, res) :
    res.write("Path Not Found")

    res.finish
  end

  # Helper Methods
  def list array, res
    array.each do |item|
      res.write "#{item}\n"
    end
  end

  def handle_search req, res
    search_term = req.params["q"]
    res.write @@items.include?(search_term) ?
        "#{search_term} is one of our items" : "Couldn't find #{search_term}"
  end

  def handle_cart res
    @@cart.size > 0 ? list(@@cart, res) : res.write("Your cart is empty")
  end

  def handle_add req, res
    # Take in a GET param with the key "item".
    item = req.params["item"]
    # Check to see if that item is in @@items and add it to the cart, if it is.
    @@items.include?(item) ? (@@cart << item; res.write("added #{item}")) :
                             # Otherwise, give an error
                             res.write("We don't have that item")
  end
  # binding.pry
end
