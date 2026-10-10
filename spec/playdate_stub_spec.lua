describe("playdate_stub import", function()
    it("returns the module on first import and nil on later imports", function()
        package.preload["stub_probe"] = function() return { name = "stub_probe" } end

        assert.are.same({ { name = "stub_probe" }, nil }, { import("stub_probe"), import("stub_probe") })
    end)
end)
