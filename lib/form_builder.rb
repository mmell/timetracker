class ActionView::Helpers::FormBuilder

  def text_area_local(meth)
    text_area(meth, {:size => '64x9'} )
  end

end
