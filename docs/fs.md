# FS Patches

As of 10.0.0+ the fs patches just bypass the signature checks on the NCA header. The original function contains some code that looks something like so:

```cpp
bool isValid = VerifyRsa2048PssSha256(param_1, 0x100, modulus, 0x100, param_3 + 0x10, 3, (int *)(param_1 + 0x200), 0x200);
if (!isValid) {
    return 0x234c02;
}
else {
    /* The signature is good. */
}
```

What this patch does is change this function to be:

```cpp
VerifyRsa2048PssSha256(param_1, 0x100, uVar7, 0x100, modulus + 0x10, 3, (int *)(param_1 + 0x200), 0x200);
/* The signature is good. */
```

In assembly we are changing the instruction `tbz w0, #0, #0x88` to `nop`, which requires patching 4 bytes: 0x40040036 to 0x1F2003D5. The location of the four bytes varies between firmware versions.
