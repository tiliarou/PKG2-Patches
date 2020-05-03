# Loader Patches

The loader patches accomplish two things: bypassing ACID signature checks, and allows running of SDK applications. The purpose of bypassing the ACID signature check is because some installers modify the ACID section of the NPDM file, which makes the signature no longer valid.

## ACID Signature Bypass

In Atmosphère they have to support all firmwares, and before firmware 10.0.0 FS handled the ACID signature checks. So to bypass ACID signature checks I just make Atmosphère think the user is on a firmware below 10.0.0. The original function of where the check is looks like so:

```cpp
Result ValidateAcidSignature(Meta *meta) {
    /* Loader did not check signatures prior to 10.0.0. */
    if (hos::GetVersion() < hos::Version_10_0_0) {
        meta->is_signed = false;
        return ResultSuccess();
    }

    // Verifies the signature...

    return ResultSuccess();
}
```

What this patch does is change this function to be:

```cpp
Result ValidateAcidSignature(Meta *meta) {
    /* Loader did not check signatures prior to 10.0.0. */
    if (hos::GetVersion() < 255) {
        meta->is_signed = false;
        return ResultSuccess();
    }

    // Verifies the signature...

    return ResultSuccess();
}
```

In assembly we are changing the instruction `cmp w0,#0xA` to `cmp w0,#0xFF`, which requires patching 2 bytes: 0x2800 to 0xFC03. The location of the two bytes varies between versions of Atmosphère.

## Running of SDK Applications

In Atmosphère they added checks to stop users from running SDK applications such as DevMenu on their retail Switches. (This is because Atmosphère's focus is to reimplement Nintendo's built-in functionality accurately.) So to make this work I just have to make Atmosphère think you are running on a development Switch. The original function looks like so:

```cpp
bool IsDevelopmentForAcidProductionCheck() {
    return g_development_for_acid_production_check;
}
```

What this patch does is change this function to be:

```cpp
bool IsDevelopmentForAcidProductionCheck() {
    return true;
}
```

In assembly we are changing the instruction `ldrb w0,[x0, #0x178]` to `mov w0,#0x1`, which requires patching 4 bytes: 0x00E44539 to 0x20008052. The location of the four bytes varies between versions of Atmosphère.
