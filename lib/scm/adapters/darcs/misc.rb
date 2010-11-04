module Scm::Adapters
	class DarcsAdapter < AbstractAdapter
		def exist?
      begin
        !!(head_token)
      rescue
        logger.debug { $! }
        false
      end
		end

    def ls_tree(token)
      # TODO make it work with tokens
      run("darcs show files --repodir='#{path}'").
        split("\n").
        reject { |filename| filename == "." }.
        map { |filename| filename.gsub(%r|^\./|, "") }
    end
    
    def export(dest_dir, token=nil)
      # TODO make it work with tokens
      # dist_name = "darcs-dist-#{rand(2**16)}"
      # run("cd '#{path}' && darcs dist --dist-name=../#{dist_name} && cd #{dest_dir}/.. && tar -xzf #{path}/../#{dist_name}.tar.gz && mv '#{dist_name}'/* #{dest_dir} && rm #{path}/../#{dist_name}.tar.gz")
      run(DarcsDist.new(path, dest_dir).command)
    end
    
    def path
      url # TODO check this and find a home for it
    end
    
    private
    
    class DarcsDist
      def initialize(repo_path, dest_dir)
        @repo_path = repo_path
        @dist_name = "darcs-dist-#{rand(2**16)}"
        @dest_dir = dest_dir
      end
      
      def command
        "#{darcs_dist} && #{untar} && #{move_files_into_dest_dir} && #{cleanup_dist_tarball} && #{cleanup_dist_dir}"
      end
      
      private
      
      def darcs_dist
        "darcs dist --repodir='#{@repo_path}' --dist-name='#{@repo_path}/../#{@dist_name}'"
      end
      
      def untar
        "tar -xzf '#{@repo_path}/../#{@dist_name}.tar.gz' -C '#{@dest_dir}/..'"
      end
      
      def move_files_into_dest_dir
        "mv '#{@dest_dir}/../#{@dist_name}'/* #{@dest_dir}"
      end
      
      def cleanup_dist_tarball
        "rm '#{@repo_path}/../#{@dist_name}.tar.gz'"
      end
      
      def cleanup_dist_dir
        "rm -r '#{@dest_dir}/../#{@dist_name}'" # TODO
      end
    end
	end
end
