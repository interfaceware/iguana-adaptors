-- This demonstrates a wrapper for the Athena RESTful web API
-- We are looking at Athena for new patients being added to the Athena application
-- Before using the Athena Adapter, please enter your consumer key and consumer secret into the config.lua file in
-- the shared/athena folder.
-- See http://help.interfaceware.com/forums/topic/athena-health-web-adapter
require 'athena.api'
config = require 'athena.config'

PracticeId = 195900

function main() 
   local A = athena.connect{username=config.username, password=config.password, cache=true}
   
   local Patients
   -- If we had a real instance of Athena Health then we would register this practice ID
   -- A.patients.patients.changed.subscription.add{practiceid=PracticeId}
   -- Then the patients.changed 
   Patients = A.patients.patients.changed.read{practiceid=195900,leaveunprocessed=iguana.isTest()}

   -- For a real athena health instance you'd like want to get rid of this line since we
   -- are querying male patients who last name is "Smith"
   --Patients = A.patients.patients.read{practiceid=PracticeId,sex='M', lastname='Smith'}
   --Patients = A.administrative.ping.read{practiceid=289301}
   local y = A.chart.chart.configuration.medicalhistory.read{practiceid=PracticeId}
   -- In this case we push the patients into the queue and we'll process them downstream.
   for i=1, #Patients.patients do  
      queue.push{data=json.serialize{data=Patients.patients[i]}}
   end
end

