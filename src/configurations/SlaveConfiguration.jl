# Defines the configuration of the Slave.
# used in the creation of the slave side algorithm.
# defines the path of the slave's local dataset to be loaded


struct SlaveConfiguration
    # for future implementations
    # host::String
    # port::Int64
    filepath::String

    SlaveConfiguration() = new()
    SlaveConfiguration(s::String) = new("")
end
