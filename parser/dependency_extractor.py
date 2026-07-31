from __future__ import annotations

import re
from typing import List, Sequence, Tuple

import networkx as nx

from .base import BaseExtractor
from .models import DependencyEdge, SectionKnowledge
from .utils import unique_preserve


class DependencyExtractor(BaseExtractor):
    def extract(self, section: SectionKnowledge, available_sections: Sequence[str]) -> Tuple[List[str], List[DependencyEdge], nx.DiGraph]:
        dependency_graph = nx.DiGraph()
        dependency_graph.add_node(section.section, title=section.title)

        references = re.findall(r"\b(?:para|paragraph|section|chapter)\s+(\d+(?:\.\d+)*)\b", section.raw_text, flags=re.IGNORECASE)
        related = [item for item in references if item != section.section]
        related.extend(candidate for candidate in available_sections if candidate != section.section and candidate in section.raw_text)
        dependencies = unique_preserve(related)

        edges: List[DependencyEdge] = []
        for dependency in dependencies:
            edge = DependencyEdge(source_section=section.section, target=dependency, relation="references")
            edges.append(edge)
            dependency_graph.add_node(dependency)
            dependency_graph.add_edge(section.section, dependency, relation=edge.relation)

        entity_refs = re.findall(r"\b[A-Z]{2,10}\b", section.raw_text)
        for entity in unique_preserve(entity_refs):
            if entity == section.section:
                continue
            dependency_graph.add_node(entity, node_type="entity")
            dependency_graph.add_edge(section.section, entity, relation="mentions")

        return dependencies, edges, dependency_graph
