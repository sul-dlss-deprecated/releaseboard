class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :resolve_params
  before_filter :authenticate_cud_requests, :except => [:index, :show]
  cattr_writer :credentials
  class << self
    credentials = {}
  end

  def resolve_id_field key, klass, subhash=nil
    p = subhash.nil? ? params : params[subhash]
    base_key = key.to_s.sub(/_id$/,'').to_sym
    unless p.nil?
      val = params.delete(key) || params.delete(base_key) || p.delete(key) || p.delete(base_key)
      if val.is_a?(String) and val !~ /^[0-9]+$/
        p[key] = klass.find_or_create_by_name(val) do |n|
          n.update_attributes params[base_key]
        end.id
      elsif val.is_a?(Fixnum) or val =~ /^[0-9]+$/
        p[key] = val.to_i
      end
    end
  end
  
  def resolve_params
  end
  
  def authenticate_cud_requests
    authenticate_or_request_with_http_basic('Admin') do |user, pass|
      user == @@credentials[:user] && pass = @@credentials[:pass]
    end
  end
end
