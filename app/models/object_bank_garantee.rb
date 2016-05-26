class ObjectBankGarantee < ActiveRecord::Base
  ObjectBankGarantee.establish_connection :mssqlObjects

  self.table_name = 'vw_ObjectForMobileInfoBankGuarant'
  self.primary_key = :object_id,:date_start,:date_end

  belongs_to :obj, foreign_key: 'ObjectID'

  alias_attribute 'object_id','ObjectID'
  alias_attribute 'code_ds','Code_DS'
  alias_attribute 'date_start','DATE_N'
  alias_attribute 'date_end','DATE_O'
  alias_attribute 'is_closed','CLOSE'

end
