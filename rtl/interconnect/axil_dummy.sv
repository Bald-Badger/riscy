import defines::*;
import axi_defines::*;

module axil_dummy_master (
	axil_interface.axil_master	m00
);

	always_comb begin : dummy_master_signal
		m00.axil_awaddr		= NULL;
		m00.axil_awprot		= 3'b0;
		m00.axil_awvalid	= INVALID;
		m00.axil_wdata		= NULL;
		m00.axil_wstrb		= 4'b0;
		m00.axil_wvalid		= INVALID;
		m00.axil_bready		= INVALID;
		m00.axil_araddr		= NULL;
		m00.axil_arprot		= 3'b0;
		m00.axil_arvalid	= INVALID;
		m00.axil_rready		= INVALID;
	end

endmodule : axil_dummy_master


module axil_dummy_slave (
	axil_interface.axil_slave	s00
);

	always_comb begin : dummy_slave_signal
		s00.axil_awready	= INVALID;
		s00.axil_wready		= INVALID;
		s00.axil_bresp		= RESP_OKAY;
		s00.axil_bvalid		= INVALID;
		s00.axil_arready	= INVALID;
		s00.axil_rdata		= NULL;
		s00.axil_rresp		= RESP_OKAY;
		s00.axil_rvalid		= INVALID;
	end

endmodule : axil_dummy_slave
