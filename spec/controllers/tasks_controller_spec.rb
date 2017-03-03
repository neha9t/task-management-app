require "rails_helper"
require 'pry'

def verify_task(task)
  expect(task.keys).to contain_exactly("id", "name", "description", "end_date_on", "created_at",
                                       "updated_at", "user_id")
  expect(task["created_at"]).to be_truthy
  expect(task["updated_at"]).to be_truthy
  expect(task["id"]).to be_truthy
  expect(task["name"]).to eq("N1")
  expect(task["description"]).to eq("D1")
  expect(task["end_date_on"]).to eq("2017-02-25")
  expect(task["user_id"]).to eq(1)
end

RSpec.describe TasksController, type: :controller do
  describe "POST #create" do
    context 'with invalid attributes' do
      before(:each) do
        @request.env["CONTENT_TYPE"] = "application/json"
        params = { name: "", description: "I am s", end_date_on: "2017-02-28" }
        post :create, params: params
      end

      it "responds with 400 HTTP Code" do
        expect(response.code).to eql("400")
      end

      it "responds with error message" do
        body = JSON.parse(response.body)
        expect(body["errors"]["name"]).to match_array(["can't be blank"])
        expect(body["errors"]["user_id"]).to match_array(["can't be blank", "is not a number"])
      end
    end

    context 'when date is invalid' do
      it "responds with 200 HTTP code" do
        @request.env["CONTENT_TYPE"] = "application/json"
        post :create, params: { name: "Neha T", description: "a", end_date_on: "2", user_id: 1 }
        body = JSON.parse(response.body)
        expect(body["errors"]["end_date_on"]).to match_array(["is not a valid date"])
        expect(response.code).to eql("400")
      end
    end

    context 'when valid' do
      it "responds with 200 HTTP code" do
        @request.env["CONTENT_TYPE"] = "application/json"
        params = { name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1 }
        post :create, params: params
        expect(response.code).to eql("200")
        body = JSON.parse(response.body)
        verify_task(body)
      end
    end
  end

  describe "GET #index" do
    context "when has valid array" do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        get :index
      end

      it "responds with 200 HTTP Code" do
        expect(response.code).to eql("200")
      end

      it "should return 2 tasks" do
        body = JSON.parse(response.body)
        expect(body.length).to eql(2)
        verify_task(body[0])
      end
    end

    context "when applied author filter on tasks" do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        get :index, params: { user_id: 2 }
      end
      it "returns values with same user_id" do
        body = JSON.parse(response.body)
        expect(body.length).to eq(2)
        expect(body[0]["user_id"]).to eq(2)
        expect(body[1]["user_id"]).to eq(2)
      end
    end

    context "when applied created_after a given date filter on tasks" do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        get :index, params: { created_after: Time.zone.today + 1.day }
      end
      it "should return 0 task" do
        body = JSON.parse(response.body)
        expect(body.length).to eql(0)
      end
    end

    context "when applied before_end_date a given date filter on tasks" do
      before(:each) do
        Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        Task.create(name: "N2", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        get :index, params: { before_date: "2017-02-23" }
      end
      it "should return 2 task" do
        body = JSON.parse(response.body)
        expect(body.length).to eql(2)
      end
    end

    context "when applied full text search filter on tasks" do
      before(:each) do
        Task.create(name: "NEHA", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "NEHAT", description: "D2", end_date_on: "2017-02-21", user_id: 2)
        Task.create(name: "NEHAM", description: "D2", end_date_on: "2017-02-21", user_id: 2)
      end
      it "will generate error" do
        get :index, params: { search: "" }
        body = JSON.parse(response.body)
        expect(body["error"]).to eql("No Results Found")
      end

      it "will generate error" do
        get :index, params: { search: "&()(" }
        body = JSON.parse(response.body)
        expect(body["error"]).to eql("No Results Found") # as search term with every special character is internally converted to ""
      end

      it "will generate error" do
        skip "is skipped" do
          get :index, params: { search: "NEHA(&^%" }
          body = JSON.parse(response.body)
          # as search term with every a combination of Letters-special chars
          # is internally converted to first encounter of letter and ditching everything after that
          expect(body.length).to eql(1)
        end
      end

      it "will generate records starting with " do
        skip "is skipped" do
          get :index, params: { search: "NEHA" }
          body = JSON.parse(response.body)
          expect(body.length).to eql(1)
        end
      end

      it "will generate error" do
        get :index, params: { search: nil }
        body = JSON.parse(response.body)
        expect(body["error"]).to eql("No Results Found")
      end
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
        task = Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        get :show, params: { id: task.id }
      end

      it "responds with 200 HTTP Code" do
        body = JSON.parse(response.body)
        expect(response.code).to eql("200")
        verify_task(body)
      end
    end
  end

  describe "PUT #update" do
    context "with invalid attributes" do
      before(:each) do
        @task = Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
      end
      it "responds with error message" do
        @request.env["CONTENT_TYPE"] = "application/json"
        put :update, params: { id: @task.id, name: "", description: "D1", end_date_on: "w", user_id: "" }
        body = JSON.parse(response.body)
        expect(response.code).to eql("400")
        expect(body["errors"]["end_date_on"]).to match_array(["is not a valid date"])
        expect(body["errors"]["user_id"]).to match_array(["can't be blank", "is not a number"])
        expect(body["errors"]["name"]).to match_array(["can't be blank"])
      end
    end

    context "with changed valid attributes" do
      before(:each) do
        @task = Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
      end
      it "responds with 200 OK" do
        @request.env["CONTENT_TYPE"] = "application/json"
        params = { id: @task.id, name: "Ch N1", description: "D1", end_date_on: "2017-02-03", user_id: 1 }
        put :update, params: params
        @task.reload
        body = JSON.parse(response.body)
        expect(response.code).to eql("200")
        expect(@task.name).to eql("Ch N1")
      end
    end
  end

  describe "DELETE #destroy" do
    context "with valid attributes" do
      it "responds with 200 status code" do
        @task = Task.create(name: "N1", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        delete :destroy, params: { id: @task.id }
        body = JSON.parse(response.body)
        expect(response.code).to eql("200")
      end
    end
    context "with ID which is already deleted" do
      it "responds with 404 and error message once deleted" do
        delete :destroy, params: { id: 1 }
        body = JSON.parse(response.body)
        expect(body["error"]).to eql("record not found")
        expect(response.code).to eql("404")
      end
    end
  end

  describe "GET #autocomplete" do
    context "with valid attributes" do
      before(:each) do
        Task.create(name: "NEHAT", description: "D1", end_date_on: "2017-02-25", user_id: 1)
        Task.create(name: "NEHAM", description: "D1", end_date_on: "2017-02-25", user_id: 1)
      end
      it "responds with autosuggestions" do
        skip "is skipped" do
          get :autocomplete, params: { search: "NEH" } # concatenate * on its own
          body = JSON.parse(response.body)
          expect(body.length).to eql(2)
        end
      end

      it "will generate error" do
        get :autocomplete, params: { search: "*" }
        body = JSON.parse(response.body)
        expect(body["error"]).to eql("Invalid Search Term")
      end
    end

  end
end
