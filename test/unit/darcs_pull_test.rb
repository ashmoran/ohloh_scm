require File.dirname(__FILE__) + '/../test_helper'

module Scm::Adapters
	class DarcsPullTest < Scm::Test

		def test_pull_creates_the_repository
      # with_hg_repository('hg') do |src|
      #   Scm::ScratchDir.new do |dest_dir|
      # 
      #     dest = HgAdapter.new(:url => dest_dir).normalize
      #     assert !dest.exist?
      # 
      #     dest.pull(src)
      #     assert dest.exist?
      # 
      #     assert_equal src.log, dest.log
      # 
      #     # Commit some new code on the original and pull again
      #     src.run "cd '#{src.url}' && touch foo && hg add foo && hg commit -u test -m test"
      #     assert_equal "test\n", src.commits.last.message
      # 
      #     dest.pull(src)
      #     assert_equal src.log, dest.log
      #   end
      # end
      
      with_darcs_repository('darcs') do |src|
        Scm::ScratchDir.new do |dest_dir|
          dest = DarcsAdapter.new(:url => dest_dir).normalize
          assert !dest.exist?

          dest.pull(src)
          
          assert dest.exist?
        end
      end
		end

		# TODO is #log even a real Ohloh method? This test seems pointless
    # def test_pull_preserves_log
    #   with_darcs_repository('darcs') do |src|
    #         Scm::ScratchDir.new do |dest_dir|
    #           dest = DarcsAdapter.new(:url => dest_dir).normalize
    #           assert !dest.exist?
    # 
    #           dest.pull(src)
    #           
    #           assert_equal src.log, dest.log
    #         end
    #       end      
    # end

	end
end
