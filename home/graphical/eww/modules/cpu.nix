{pop, ...}: ''
  (defwidget cpu []
    (circular-progress
      :value "''${EWW_CPU.avg}"
      :class "cpubar module"
      :thickness 3
      (button
        :tooltip "using ''${round(EWW_CPU.avg,0)}% cpu"
        :onclick "${pop} system"
        (label :class "icon_text" :text ""))))
''
