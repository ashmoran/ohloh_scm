module Scm::Adapters
	class DarcsAdapter < AbstractAdapter
		def head_token
      # tokens = []
      # run("darcs changes --context --repo=#{url}").each_line do |line|
      #   tokens << $1 if line =~ /Ignore-this: (\w+)/
      # end
      # tokens.reverse.join(";")
		  run("darcs changes --xml-output --repo=#{url}").each_line do |line|
		    return $1 if line =~ /hash='([^'.]+)(?:\.gz)?'/
		  end
		  ""
		end

    # def head
    #   verbose_commit(head_token)
    # end
    # 
    # def parent_tokens(commit)
    #   run("cd '#{url}' && hg parents -r #{commit.token} --template '{node}\\n'").split("\n")
    # end
    # 
    # def parents(commit)
    #   parent_tokens(commit).collect { |token| verbose_commit(token) }
    # end
	end
end
