% Don't Mind Me
function tick_change(f)
    ph = f.XTick./2;
    ph = num2str(ph(:));
    f.XTickLabel = ph;
end