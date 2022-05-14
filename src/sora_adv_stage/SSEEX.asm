loc_muAdvSelchrCTask__setMenuData_checkIfOverride:
    li r14, 0x0            # Default setting (no override)
    lis r8, 0x805B         # \         
    ori r8, r8, 0xACC0     # / Get global gfPadSystem       
    li r7, 0x0                      # \
    li r3, 0x46                     # |
loc_checkForOverrideInput:          # |
    lhzx r5, r3, r8                 # | 
    andi. r5, r5, 0x0040            # | Check for L input in each gfPadStatus
    bne- loc_teamMemberOverride     # |
    addi r3, r3, 0x40               # |
    addi r7, r7, 0x1                # |
    cmpwi r7, 0x8                   # |
    ble+ loc_checkForOverrideInput   # /
    beq- cr7, loc_oneTeamNoOverride
    b __unresolved                   [R_PPC_REL24(40, 1, "loc_multipleTeams")]         # Original branch operation
loc_teamMemberOverride:
    li r14, 0x1         # Set override
loc_oneTeamNoOverride:
    b __unresolved                    [R_PPC_REL24(40, 1, "loc_3E9AC")]


loc_muAdvSelchrCTask__setMenuData_overrideSave:
    lwz r0,0x4898(r3)       # Original operation, get save data
    cmpwi r14, 0x1
    bne- loc_noSaveDataOverride
    lis r0, 0xBFF9          # Override with completed character save data
    ori r0, r0, 0xFFFF      # 
loc_noSaveDataOverride:
    blr


loc_muAdvSelchrCTask__setMenuData_addExTeamMembers:
    stw r31,0x6F8(r29)
    lis r12,0x0            [R_PPC_ADDR16_HA(40, 8, "loc_NumAddedTeamMembers")]
    lbz r5,0x0(r12)        [R_PPC_ADDR16_LO(40, 8, "loc_NumAddedTeamMembers")] # Get Number of additional team members 
    
    lwz r3, 0xe4(r29)      # Get current team members
    lis r4,0x0            [R_PPC_ADDR16_HA(40, 8, "loc_AddedTeamMemberIds")]
    addi r4,r4,0x0        [R_PPC_ADDR16_LO(40, 8, "loc_AddedTeamMemberIds")]
    
    cmpwi r14, 0x1         # Check if override
    bne- loc_notOverride 
    addi r5, r5, 0x1     
    subi r4, r4, 0x1     # Add Sonic since for some reason not included when overriding save
    b loc_addFightersToTeamMenu
loc_notOverride:
    lis r12, 0x9018         # \
    lwz r12, 0x1330(r12)    # | Check if Great Maze has been completed
    lwz r12, 0x29C(r12)     # |
    cmpwi r12, 0x0          # /
    ble loc_skipAddFightersToTeamMenu
loc_addFightersToTeamMenu:
    add r6, r5, r3       # Add number of additional team members to get total team members
    stw r6, 0xe4(r29)      # Store team member count
    addi r7, r3, 0x44      # Add to array offset
    add r3, r7, r29
    bl __unresolved                          [R_PPC_REL24(0, 1, "loc_80004338")] # memcpy rel css data section to team member 1 section
loc_skipAddFightersToTeamMenu:
    b __unresolved                           [R_PPC_REL24(40, 1, "loc_3EBCC")]

# TODO: Fix trophies
# TODO: Force setMenuData to pop up to select fighters? (will probs get overidden by selection)

# TODO: Investigate if any offsets were missed, (visual bug with the Select number not going down as Fighters are selected)
# TODO: Fix Great Maze sometimes resetting to Mario when selecting save also Tabuu fight?
# TODO: Random selection?