require "rails_helper"
require 'pry'



describe TasksController do
  describe "POST #create" do
    context 'with invalid attributes' do
      before(:each) do
        @request.env["CONTENT_TYPE"] = "application/json"
        params = {name: "", description: "I am description", end_date_on: "2017-02-28"}
        post :create, params: params
      end

      it "responds with 400 HTTP Code" do
        expect(response.code).to eql("400")
      end

      it "responds with error message" do
        body = JSON.parse(response.body)
        puts body
        expect(body["errors"]["name"]).to match_array(["can't be blank"])
        expect(body["errors"]["user_id"]).to match_array(["can't be blank", "is not a number"])
      end
    end

    context 'when date is invalid' do
      it "responds with 200 HTTP code" do
        @request.env["CONTENT_TYPE"] = "application/json"
        post :create , params: {name: "Neha T", description: "description", end_date_on: "!@#{}", user_id: 1}
        body = JSON.parse(response.body)
        puts body
        expect(body["errors"]["end_date_on"]).to match_array(["is not a valid date"])
        expect(response.code).to eql("400")
        #   # expect(response.code).to eql("200")
        #   #body = JSON.parse(response.body)
        #   expect(body.keys).to contain_exactly("id","name", "description", "end_date_on", "created_at", "updated_at", "user_id")
        #   # TODO - Write tests to match exact value of known fields.
        #   expect(body["created_at"]).to be_truthy
        #   expect(body["updated_at"]).to be_truthy
        #   expect(body["id"]).to be_truthy
        # end
      end
    end


    context 'when valid' do
      it "responds with 200 HTTP code" do
        @request.env["CONTENT_TYPE"] = "application/json"
        post :create , params: {name: "Neha T", description: "description", end_date_on: "2017-02-23", user_id: 1}
        expect(response.code).to eql("200")
        body = JSON.parse(response.body)
        expect(body.keys).to contain_exactly("id","name", "description", "end_date_on", "created_at",
                                             "updated_at", "user_id")
        # TODO - Write tests to match exact value of known fields.
        expect(body["created_at"]).to be_truthy
        expect(body["updated_at"]).to be_truthy
        expect(body["id"]).to be_truthy
      end
    end
  end

  describe "GET #index" do
    context "no values" do
      before(:each) do
        get :index
      end

      it "responds with 200 HTTP Code" do
        expect(response.code).to eql("200")
      end

      # it "responds with array of tasks" do
      #   expect(assigns(:tasks)).to match_array @task
      #   # expect(response).to have_http_status(400)
      # end
    end

    context "should return values" do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25")
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21")
        get :index
      end

      it "responds with 200 HTTP Code" do
        expect(response.code).to eql("200")
      end

      it "should return two tasks" do
        expect(JSON.parse(response.body).length).to eql(2)
        # TODO - Do same checks as post, encapsulate within a function.
      end

      # it "responds with array of tasks" do
      #   expect(assigns(:tasks)).to match_array @task
      #   # expect(response).to have_http_status(400)
      # end
    end
  end

  describe "GET #show" do
    context 'with invalid id' do
      before(:each) do
        get :show, params: { id: 90 }
      end

      it "responds with 404 HTTP Code" do
        expect(response.code).to eql("404")
      end

      it "responds with error message" do
        expect(JSON.parse(response.body)["error"]).to eql("record not found")
      end
    end

    context 'with valid id' do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25")
        get :show, params: { id: 1 }
      end

      it "responds with 200 HTTP Code" do
        puts response.body
        expect(response.code).to eql("200")
        # TODO - Response structure
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      before(:each) do
        put :update , params: {}
      end
    end

  end
end


# context 'when valid' do
#   it "responds successfully with an HTTP 200 status code" do
#     @request.env["CONTENT_TYPE"] = "application/json"
#     post :create, params: {name: "NEHA", description: "QWRTW", end_date_on: "2017-02-23"}
#     expect(response).to have_http_status(200)
#     body = JSON.parse(response.body)
#     expect(body.keys).to contain_exactly("id","name", "description", "end_date_on", "created_at", "updated_at")
#     # TODO - Write tests to match exact value of known fields.
#     expect(body["created_at"]).to be_truthy
#     expect(body["updated_at"]).to be_truthy
#     expect(body["id"]).to be_truthy
#   end
# end
# it "renders the index template" do
#   get :index
#   expect(response).to render_template("index")
# end

#it : aparams :  nhe posts:to @posts"do
#   :t1, post2 = Post.create!, Post.create!
#   get :index

#   expect(assigns(:posts)).to match_array([post1, post2])
# # end
# end
# end
