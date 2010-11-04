require File.dirname(__FILE__) + '/../test_helper'

module Scm::Adapters
	class DarcsHeadTest < Scm::Test

    # def test_head_and_parents
    #   with_hg_repository('hg') do |hg|
    #     assert_equal '75532c1e1f1d', hg.head_token
    #     assert_equal '75532c1e1f1de55c2271f6fd29d98efbe35397c4', hg.head.token
    #     assert hg.head.diffs.any? # diffs should be populated
    # 
    #     assert_equal '468336c6671cbc58237a259d1b7326866afc2817', hg.parents(hg.head).first.token
    #     assert hg.parents(hg.head).first.diffs.any?
    #   end
    # end
    
    def test_head_token_is_last_applied_patch_hash
      with_darcs_repository("darcs") do |darcs|
        assert_equal '20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78', darcs.head_token
      end
      
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal '20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620', darcs.head_token
      end
    end
        
    def test_something_is_present_in_diffs
      with_darcs_repository("darcs_tagged") do |darcs|
        assert darcs.head.diffs.any?
      end
    end
    
    def test_something_is_present_in_diffs_of_first_parent
      with_darcs_repository("darcs_tagged") do |darcs|
        assert darcs.parents(darcs.head).first.diffs.any?
      end
    end

	end
end
