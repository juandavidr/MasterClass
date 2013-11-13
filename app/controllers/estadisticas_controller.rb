
class EstadisticasController < ApplicationController
  
  def index    
    
    @barChartEstMaes = LazyHighCharts::HighChart.new('graph') do |f|
      
      f.title({ :text=>"Estudiantes inscritos por maestria"})
      
       
      f.options[:xAxis][:categories] = ['Maestrias']
     
      #      Grafica de columnas
     
      #      f.labels(:items=>[:html=>"Estudiantes inscritos por maestria",
      #          :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ])  

      @usrsprogs =  UserProgram.joins(:program).select("count(*) as count,programs.name as name").group("programs.name")
     
      
      @usrsprogs.each do |st|
        f.series(:type=> 'column',:name=> st.name,:data=> [st.count])
      end 
      
      #      f.series(:type=> 'column',:name=> 'John',:data=> [2, 3, 5, 7, 6])
      #      f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])

      #    Pie chart
      #      f.series(:type=> 'pie',:name=> 'Total consumption', 
      #        :data=> [
      #          {:name=> 'Jane', :y=> 13, :color=> 'red'}, 
      #          {:name=> 'John', :y=> 23,:color=> 'green'},
      #          {:name=> 'Joe', :y=> 19,:color=> 'blue'}
      #        ],
      #        :center=> [100, 80], :size=> 100, :showInLegend=> false)
      #      Grafica de linea
      #        f.series(:type=> 'spline',:name=> 'Average', :data=> [3, 2.67, 3, 6.33, 3.33])
    end
    
    @barChartEstClass = LazyHighCharts::HighChart.new('graph') do |f|
      
      f.title({ :text=>"Estudiantes inscritos por materia"})
      f.options[:xAxis][:categories] = ['Materias']
     f.labels(:items=>[:html=>"Estudiantes inscritos por materia",
                :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ]) 
      #      Grafica de columnas
      @usrssubj =  PreregisterSubject.joins(:subject).select("count(*) as count,name as name").group("name").order("subjects.id")
      
      @usrssubj.each do |st|
        f.series(:type=> 'column',:name=> st.name,:data=> [st.count])
      end 
    end
  end
end