class MoneyInput < SimpleForm::Inputs::Base
    def input(wrapper_options) 
        if html5?
            input_html_options[:step] ||= 0.01
        end
        merged_input_option = merge_wrapper_options(input_html_options, wrapper_options)
        @builder.number_field(attribute_name, merged_input_option)
    end
end