# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'pathname'
require 'yaml'

load File.expand_path('../.gemspec', __dir__)

class GemspecExporterScmTest < Minitest::Test
  def build_metadata(root)
    {
      'revision' => Indexer::GemspecExporter::REVISION,
      'name' => 'demo',
      'title' => 'Demo',
      'version' => '0.0.1',
      'summary' => 'summary',
      'description' => 'description',
      'authors' => [{'name' => 'Test Author'}],
      'requirements' => [],
      'resources' => [],
      'copyrights' => [],
      'paths' => {'load' => ['lib']},
      :root => Pathname.new(root)
    }
  end

  def test_scm_is_nil_when_no_supported_repo_exists
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, '.index'), "revision: #{Indexer::GemspecExporter::REVISION}\n")

      exporter = Indexer::GemspecExporter.new(build_metadata(dir))

      assert_nil exporter.scm
    end
  end

  def test_scm_detects_git_repo
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, '.index'), "revision: #{Indexer::GemspecExporter::REVISION}\n")
      Dir.mkdir(File.join(dir, '.git'))

      exporter = Indexer::GemspecExporter.new(build_metadata(dir))

      assert_equal :git, exporter.scm
    end
  end
end
