require File.dirname(__FILE__) + '/../test_helper'

module Scm::Adapters
	class DarcsCommitsTest < Scm::Test

    # def test_commit
    #   with_hg_repository('hg') do |hg|
    #     assert_equal ['01101d8ef3cea7da9ac6e9a226d645f4418f05c9',
    #                   'b14fa4692f949940bd1e28da6fb4617de2615484',
    #                   '468336c6671cbc58237a259d1b7326866afc2817',
    #                   '75532c1e1f1de55c2271f6fd29d98efbe35397c4'], hg.commits.collect { |c| c.token }
    # 
    #     assert_equal ['75532c1e1f1de55c2271f6fd29d98efbe35397c4'],
    #       hg.commits('468336c6671cbc58237a259d1b7326866afc2817').collect { |c| c.token }
    # 
    #     # Check that the diffs are not populated
    #     assert_equal [], hg.commits('468336c6671cbc58237a259d1b7326866afc2817').first.diffs
    # 
    #     assert_equal [], hg.commits('75532c1e1f1de55c2271f6fd29d98efbe35397c4')
    #   end
    # end

    def test_commit_count_is_number_of_patches
      with_darcs_repository("darcs") do |darcs|
        assert_equal 4, darcs.commit_count
      end
      
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal 5, darcs.commit_count
      end
    end
    
    def test_commit_count_returns_number_of_patches_since_specified_patch_hash
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal 4, darcs.commit_count("20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e")
        assert_equal 3, darcs.commit_count("20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf")
        assert_equal 2, darcs.commit_count("20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc")
        assert_equal 1, darcs.commit_count("20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78")
        assert_equal 0, darcs.commit_count("20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620")
      end
    end
    
    def test_commit_tokens_returns_tokens_in_ascending_chronological_apply_order
      with_darcs_repository("darcs") do |darcs|
        assert_equal ["20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e",
                      "20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf",
                      "20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                      "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78"], darcs.commit_tokens
      end
      
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal ["20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e",
                      "20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf",
                      "20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                      "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                      "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"], darcs.commit_tokens
      end
    end
    
    def test_commit_tokens_returns_tokens_since_specified_patch_hash
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal  ["20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf",
                       "20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                       "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commit_tokens("20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e")

        assert_equal  ["20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                       "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commit_tokens("20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf")

        assert_equal  ["20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commit_tokens("20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc")

        assert_equal  ["20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commit_tokens("20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78")

        assert_equal  [],
                      darcs.commit_tokens("20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620")
      end
    end
    
    def test_commits_returns_objects_with_tokens
      with_darcs_repository("darcs_tagged") do |darcs|
        assert_equal  ["20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf",
                       "20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                       "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commits("20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e").map { |commit| commit.tokens }

        assert_equal  ["20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc",
                       "20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commits("20090807154251-4d908-8aa16fe437c99e1fe24898af6bce8f34f51390bf").map { |commit| commit.tokens }

        assert_equal  ["20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78",
                       "20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commits("20090807154252-4d908-309a4b6c9285e371764318f591f412f11cb584fc").map { |commit| commit.tokens }

        assert_equal  ["20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620"],
                      darcs.commits("20090807154253-4d908-1a4a41e9d29c32009e147f826b5e185c7495ff78").map { |commit| commit.tokens }

        assert_equal  [],
                      darcs.commits("20090807154254-4d908-5c7ca60a21c691481da250b0c95f936cdeead620").map { |commit| commit.tokens }
      end
      
    end
    
    def test_commits_creates_and_cleans_up_log_file
      with_darcs_repository("darcs") do |darcs|
        darcs.each_commit do |commit|
          assert FileTest.exist?(darcs.log_filename)
        end
        assert !FileTest.exist?(darcs.log_filename)
      end
    end
    
    def test_each_commit
      commits = []
      with_darcs_repository("darcs_tagged") do |darcs|
        darcs.each_commit do |commit|
          commits << commit
        end
        assert !FileTest.exist?(darcs.log_filename)
      end
      
      assert_equal "20090807154250-4d908-80dcae525138a9ee03aa2af1628557d9e260e46e", commits[0].token
      assert_equal "Robin Luckey", commits[0].committer_name
      assert_equal Time.new("2009", "8", "7", "15", "42", "50"), commits[0].committer_date
      assert_equal commits[0].message.length > 0 # TODO
      assert_equal commits[0].diffs.any? # TODO
      
      # Check that the diffs are populated
      c.diffs.each do |d|
        assert d.action =~ /^[MAD]$/
        assert d.path.length > 0
      end
      
    end
    
	end
end

