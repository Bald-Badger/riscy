module axil_dummy_master (
	axi_lite_interface	m00
);

	always_comb begin : dummy_master_signal
		
	end

endmodule : axil_dummy_master

module axil_dummy_slave (
	axi_lite_interface	s00
);

	always_comb begin : dummy_slave_signal

	end

endmodule : axil_dummy_slave
