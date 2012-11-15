require 'rho/rhocontroller'
require 'pdf/writer.rb'

class GeneratePDFController < Rho::RhoController
  @layout = :simplelayout
  
  def index
      render :back => '/app'
  end




  
  def make_pdf
        # prepare DPF file on local file system in User folder
        #
        # for generate PDF we use open source pure Ruby library PDF-Writer
        # Homepage::  http://rubyforge.org/projects/ruby-pdf/
        # Copyright:: 2003-2005, Austin Ziegler
        # 
        # PDF-Writer also require few additional Ruby libs:
        #   color
        #   transaction-simple
        #   thread
        #
        # You can see their Ruby code in rodes platform extension folder:
        #  [Rhodes root]/lib/extensions
        # 
        # for include that libs to your application you should add next extsnions to your application extension list in your application build.yml :
        # "pdf-writer", "thread"
        #

        pdf = PDF::Writer.new

        # Do some funky stuff in the background, in a nice light blue, which is
        # bound to clash with something and some red for the hell of it
        x   = 578
        r1  = 25

        40.step(1, -3) do |xw|
             tone = 1.0 - (xw / 40.0) * 0.2

             pdf.stroke_style(PDF::Writer::StrokeStyle.new(xw))
             pdf.stroke_color(Color::RGB.from_fraction(tone, 1, tone))
             pdf.circle_at(50, 750, r1).stroke
             r1 += xw
        end

        40.step(1, -3) do |xw|
             tone = 1.0 - (xw / 40.0) * 0.2

             pdf.stroke_style(PDF::Writer::StrokeStyle.new(xw))
             pdf.stroke_color(Color::RGB.from_fraction(tone, tone, 1))
             pdf.line(x, 0, x, 842)
             x = (x - xw - 2)
        end

        pdf.stroke_color(Color::RGB::Black)
        pdf.stroke_style(PDF::Writer::StrokeStyle.new(1))
        pdf.rectangle(20, 20, 558, 802)

        y = 800
        50.step(5, -5) do |size|
             height = pdf.font_height(size)
             y = y - height

             pdf.add_text(30, y, 'example text', size)
        end

        (0...360).step(20) do |angle|
             pdf.fill_color(Color::RGB.from_fraction(rand, rand, rand))

             pdf.add_text( 300 + Math.cos(PDF::Math.deg2rad(angle)) * 40,
                                  300 + Math.sin(PDF::Math.deg2rad(angle)) * 40,
                                  'example text', 20, angle)
        end

        fileNameW = File.join(Rho::RhoApplication::get_user_path(), 'demo.pdf')

        pdf.save_as(fileNameW)

  end
  
  def open_pdf
        # open/print PDF on iOS by open in standart preview contol
        # in this control user can make with showed file few things:
        #    preview
        #    send via mail etc.
        #    print
        #    open in another application
        
        make_pdf

        fileNameR = File.join(Rho::RhoApplication::get_user_path(), 'demo.pdf')
        System.open_url(fileNameR)
        redirect :action => :index

  end

  def capture_jpeg
    filename = File.join(Rho::RhoApplication::get_user_path(), 'capture.jpeg')
    #filename = '/sdcard/capture.jpg'
    WebView.save 'jpeg', filename    
    Rho::Timer.start(500, url_for(:action => :capture_callback), "filename=#{filename}")
    redirect :action => :index
  end
  
  def capture_callback
    filename = @params['filename']
    puts "trying to open #{filename}"    
    System.open_url filename
  end
end
