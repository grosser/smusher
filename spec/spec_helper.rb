require 'rubygems'

$LOAD_PATH << 'lib'
require 'smusher'

# separate key for testing
Smusher::PunyPng.api_key = '3cbb0102ca6d000370f2d5b34ca0125d67b801dc'

ROOT = File.expand_path(File.dirname(__FILE__))