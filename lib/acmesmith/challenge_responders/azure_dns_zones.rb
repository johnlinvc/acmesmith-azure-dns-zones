require "acmesmith/challenge_responders/base"

require 'azure_mgmt_dns'


module Acmesmith
  module ChallengeResponders
    class AzureDnsZones < Base

      def support?(type)
        type == 'dns-01'
      end

      def cap_respond_all?
        false
      end

      def initialize(config)
        @client = Azure::Dns::Profiles::Latest::Mgmt::Client.new(config)
      end

      def find_managed_zone(domain)
        managed_zone = @client.zones.list.select do |zone|
          /(?:\A|\.)#{Regexp.escape(zone.name)}\z/ =~ domain
        end.max_by{ |zone| zone.name.size}
        if managed_zone.nil?
          raise "Domain not found in Azure managed dns zones"
        end
        managed_zone
      end

      def find_existing_record(zone, challenge)
        @client.record_sets.list_by_dns_zone(zone.resource_group, zone.name).find{ |r| r.name == challenge.record_name && r.type == challenge.record_type }
      end

      def relative_record_name(zone, domain, challenge)
        fullname = challenge.record_name + "." +domain
        fullname.gsub(/\.#{Regexp.escape(zone.name)}\z/, "")
      end

      def create(zone, domain, challenge)
        record_name = relative_record_name(zone, domain, challenge)
        system("az network dns record-set #{challenge.record_type} add-record -g #{zone.resource_group} -z #{zone.name} -n #{record_name} -v \"#{challenge.record_content}\"")
      end

      def delete(zone, domain, challenge)
        record_name = relative_record_name(zone, domain, challenge)
        system("az network dns record-set #{challenge.record_type} remove-record -g #{zone.resource_group} -z #{zone.name} -n #{record_name} -v \"#{challenge.record_content}\"")
      end

      def respond(domain, challenge)
        zone = find_managed_zone(domain)
        exisiting_record = find_existing_record(zone, challenge)
        delete(zone, domain, challenge) if exisiting_record
        #require 'byebug'; byebug
        create(zone, domain, challenge)
        #exit 1
      end

      def cleanup(domain, challenge)
        zone = find_managed_zone(domain)
        exisiting_record = find_existing_record(zone, challenge)
        delete(zone, challenge) if exisiting_record
      end

    end
  end
end
