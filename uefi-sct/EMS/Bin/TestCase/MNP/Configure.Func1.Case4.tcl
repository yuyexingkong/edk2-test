# 
#  Copyright 2006 - 2010 Unified EFI, Inc.<BR> 
#  Copyright (c) 2010, Intel Corporation. All rights reserved.<BR>
# 
#  This program and the accompanying materials
#  are licensed and made available under the terms and conditions of the BSD License
#  which accompanies this distribution.  The full text of the license may be found at 
#  http://opensource.org/licenses/bsd-license.php
# 
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
# 
################################################################################
CaseLevel         FUNCTION
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid        2E31C46B-AB6D-49df-AFFE-C790F0A714AC
CaseName        Configure.Func1.Case4
CaseCategory    MNP
CaseDescription {Test the Configure function of MNP - Call MNP.Configure()     \
	               when ReceiveQueueTimeout enabled. }
################################################################################

Include MNP/include/Mnp.inc.tcl

#
# Begin log ...
#
BeginLog
BeginScope _MNP_CONFIGURE_FUNCTION1_CASE4_

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
UINTN                            R_Status
UINTN                            R_Handle
EFI_MANAGED_NETWORK_CONFIG_DATA  R_MnpConfData

MnpServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mnp.Configure - Create Child 1"                               \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetMnpConfigData R_MnpConfData 0 0 0 FALSE TRUE FALSE FALSE FALSE FALSE FALSE; 

#
# Config ReceiveTimeout 
#
SetVar    R_MnpConfData.ReceivedQueueTimeoutValue    10
Mnp->Configure "&@R_MnpConfData, &@R_Status"
GetAck
set  assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $MnpConfigureFunc1AssertionGuid004                     \
                "Mnp.Configure - Call Configure() when Enable                  \
                ReceiveQueueTimeout."                                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Destroy Child
#
MnpServiceBinding->DestroyChild {@R_Handle, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid "Mnp.Configure - Create Child 1" \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

EndScope _MNP_CONFIGURE_FUNCTION1_CASE4_

#
# End Log
#
EndLog
