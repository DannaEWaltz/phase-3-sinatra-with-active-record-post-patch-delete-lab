class ApplicationController < Sinatra::Base
  set default_content_type: "application/json"

  get '/' do
    "hi"
  end
  
  get '/bakeries' do
    bakeries = Bakery.all
    bakeries.to_json
  end
  
  get '/bakeries/:id' do
    bakery = Bakery.find(params[:id])
    bakery.to_json(include: :baked_goods)
  end

  get '/baked_goods/by_price' do
    # see the BakedGood class for the  method definition of `.by_price`
    baked_goods = BakedGood.by_price
    baked_goods.to_json
  end

  get '/baked_goods/most_expensive' do
    # see the BakedGood class for the  method definition of `.by_price`
    baked_good = BakedGood.by_price.first
    baked_good.to_json
  end

  post "/bakeries" do
    new_bake = Bakery.create(
      name: params["name"],
    )
    new_bake.to_json
  end

  post "/baked_goods" do
    if Bakery.find_by(id: params["bakery_id"])
    new_baked_good = BakedGood.create(
      name: params["name"],
      price: params["price"],
      bakery_id: params["bakery_id"],
    )
    new_baked_good.to_json
  else
    {"error": "nice try"}.to_json
  end
end

  patch '/bakeries/:id' do
    bake_to_be_updated = Bakery.find_by(id: params[:id])
    if bake_to_be_updated
      bake_to_be_updated.update(name: params[:name])
      bake_to_be_updated.to_json
    else
      {"error": "uhoh"}.to_json
    end
  end

  delete '/baked_goods/:id' do
    found_baked_good = BakedGood.find_by(id: params[:id])
    found_baked_good.destroy 
    found_baked_good.to_json 
    # if found_baked_good
    #   status 204
    #   #head :no_content
    #   #found_baked_good.delete
    # else
    #   status 404
    #   {"error": "uhoh"}.to_json
    # end
  end

end
