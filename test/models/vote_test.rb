require "test_helper"

describe Vote do
  before do
    @new_user = User.create!(username: "Mochi Cat")
    
    
    @new_work = Work.create!(
      category: "book", 
      title: "Harry Potter", 
      creator: "JK Rowling", 
      publication_year: 1990,
      description: "great book"
    )
    
    @new_vote = Vote.new(work_id: @new_work.id, user_id: @new_user.id)
  end
  
  describe "validations" do
    it "can instantiate a valid vote" do
      expect(@new_vote.save).must_equal true
    end
    
    it "will have the required fields" do
      @new_vote.save
      vote = Vote.last
      
      [:work_id, :user_id].each do |field|
        expect(vote).must_respond_to field
      end
    end
    
    it "will not instantiate a vote without a valid work_id" do
      @new_vote.work_id = nil
      
      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :work
      expect(@new_vote.errors.messages[:work]).must_equal ["must exist"]
      
      @new_vote.work_id = -1
      
      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :work
      expect(@new_vote.errors.messages[:work]).must_equal ["must exist"]
    end
    
    it "will not instantiate a vote without a valid user_id" do
      @new_vote.user_id = nil
      
      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :user
      expect(@new_vote.errors.messages[:user]).must_equal ["must exist"]
      
      @new_vote.user_id = -1
      
      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :user
      expect(@new_vote.errors.messages[:user]).must_equal ["must exist"]
    end
    
    it "cannot instantiate a vote with the same user and work id combinations" do
      @new_vote.save
      duplicate_vote = Vote.new(work_id: @new_work.id, user_id: @new_user.id)
      
      expect(duplicate_vote.valid?).must_equal false
      expect(duplicate_vote.errors.messages).must_include :user_id
      expect(duplicate_vote.errors.messages[:user_id]).must_equal ["has already voted for this work"]
    end
  end
  
  describe "relationships" do
    describe "belongs to a user" do
      it "can set the user through user" do
        vote = Vote.new(work_id: @new_work.id)
        
        vote.user = @new_user
        
        expect(vote.user_id).must_equal @new_user.id
      end
      
      it "can set the user through user_id" do
        vote = Vote.new(work_id: @new_work.id)
        
        vote.user_id = @new_user.id
        
        expect(vote.user).must_equal @new_user
      end
    end
    
    describe "belongs to a work" do
      it "can set the work through work" do
        vote = Vote.new(user_id: @new_user.id)
        
        vote.work = @new_work
        
        expect(vote.work_id).must_equal @new_work.id
      end
      
      it "can set the work through work_id" do
        vote = Vote.new(user_id: @new_user.id)
        
        vote.work_id = @new_work.id
        
        expect(vote.work).must_equal @new_work
      end
    end
  end
end
