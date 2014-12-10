#!/usr/bin/env ruby

# file: mymedia-dynarex.rb

require 'fileutils'
require 'mymedia'


class MyMediaDynarexException < Exception
end

class MyMediaDynarex < MyMedia::Base

  def initialize(media_type: 'mmdynarex', public_type: 'dynarex', config: nil)
    
    @xsl = '/xsl/dynarex-c.xsl'
    super(media_type: media_type, public_type: @public_type=public_type, config: config)
    @media_src = "%s/media/%s" % [@home, public_type]
    @target_ext = '.xml'
    @rss = true    
  end

  def copy_publish(filename, raw_msg='')

    src_path = File.join(@media_src, filename)
    
    unless File.exists? src_path then
      raise MyMediaDynarexException, "file not found : " + src_path 
    end

    file_publish(src_path, raw_msg) do |destination, raw_destination|

      if not raw_msg or raw_msg.empty? then        
        raw_msg = File.basename(src_path) + " updated: " + Time.now.to_s
      end
      
      if File.extname(src_path) == '.txt' then
        dynarex, raw_msg = copy_edit(src_path, destination)
        copy_edit(src_path, raw_destination)
      else

        dynarex = Dynarex.new(src_path)
        title = dynarex.summary['title'] || ''
        dynarex.summary[:original_source] = File.basename(src_path)
        
        dynarex.xslt = '/xsl/dynarex-c.xsl' unless dynarex.xslt
        dynarex.save(destination)

      end

        if not File.basename(src_path)[/d\d{6}T\d{4}\.txt/] then
          xml_filename = File.basename(src_path).sub(/txt$/,'xml')
          FileUtils.cp destination, @home + '/dynarex/' + xml_filename
          if File.extname(src_path) == '.txt' then
            FileUtils.cp src_path, @home + '/dynarex/' + File.basename(src_path)
          end

          dynarex_filepath = @home + '/dynarex/static.xml'
          
          if dynarex.type == 'feed' then
            @static_baseurl = "%s/%s/%s/" % [@website, @public_type, \
                                    File.basename(src_path)[/.*(?=\.\w+$)/]]
            target_url = @static_baseurl + dynarex.records.first.last[:id]
          else
            target_url = "%s/dynarex/%s" % [@website, xml_filename]
          end

          publish_dynarex(dynarex_filepath, {title: xml_filename, url: target_url })
          
        end
      
      [raw_msg,target_url]
    end    

  end
  
  def copy_edit(src_path, destination, raw='')
    txt_destination = destination.sub(/xml$/,'txt')
    FileUtils.cp src_path, txt_destination        

    dynarex = Dynarex.new
    buffer = File.read(src_path)

    dynarex.parse(File.read(src_path))
    
    title = dynarex.summary[:title]

    if dynarex.summary['tags'] then
      tags = '#' + dynarex.summary['tags'].split.join(' #') 
    else
      tags = ''
    end
    
    raw_msg = ("%s %s" % [title, tags]).strip
    
    if dynarex.type == 'feed' then

      h = dynarex.to_h.first

      if h[:tags] then
        tags = h[:tags].gsub(/\b\w/,'#\0')
        s = h.first.last
        raw_msg = ((s + tags).length > 130 ? s[0..127] + '...' : s) \
            + ' ' + tags                            
      end
    end        
    
    dynarex.summary[:original_source] = File.basename(src_path)
    dynarex.summary[:source] = File.basename(txt_destination)
    
    dynarex.xslt = @xsl unless dynarex.xslt
    dynarex.save(destination)

    [dynarex, raw_msg]
  end
  
end
